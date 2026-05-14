import { useEffect, useState } from 'react';
import { participants as participantsApi, reference } from '../api/client';
import type { Skill, Position } from '../types';
import Th from './ui/Th';

// ─── Types from API response ──────────────────────────────────────────────────

interface RosterEntryFull {
  id: number;
  positionId: number;
  dorsal: number | null;
  playerName: string | null;
  spp: number;
  injured: boolean;
  mvUp: number;
  stUp: number;
  agUp: number;
  paUp: number;
  avUp: number;
  position: {
    id: number;
    name: string;
    ma: number; st: number; ag: number; pa: number | null; av: number;
    cost: number;
    skills: Array<{ skill: { id: number; name: string } }>;
  };
  skills: Array<{ skill: { id: number; name: string } }>;
}

interface ParticipantFull {
  id: number;
  teamName: string | null;
  rerolls: number;
  hasApothecary: boolean;
  teamValue: number;
  isVeteran: boolean;
  cheerleaders: number;
  assistantCoaches: number;
  fanFactor: number;
  treasury: number;
  player: { id: number; name: string };
  race: { id: number; name: string; rerollCost: number; imageUrl: string | null };
  roster: RosterEntryFull[];
}

// ─── Edit row state ────────────────────────────────────────────────────────────

interface EditRow {
  positionId: number | null;
  dorsal: string;
  playerName: string;
  spp: number;
  injured: boolean;
  additionalSkillIds: number[];
  mvUp: number;
  stUp: number;
  agUp: number;
  paUp: number;
  avUp: number;
  positionName: string;
  ma: number; st: number; ag: number; pa: number | null; av: number;
  baseSkills: string[];
  cost: number;
}

const UPGRADE_COSTS = { mv: 20000, st: 60000, ag: 30000, pa: 20000, av: 10000 };

function upgradeTV(row: EditRow) {
  if (row.injured) return 0;
  return row.mvUp * UPGRADE_COSTS.mv + row.stUp * UPGRADE_COSTS.st
    + row.agUp * UPGRADE_COSTS.ag + row.paUp * UPGRADE_COSTS.pa + row.avUp * UPGRADE_COSTS.av;
}

const PLAYER_RANKS = ['', 'Experimentado', 'Veterano', 'Estrella emergente', 'Estrella', 'Superestrella', 'Leyenda'];

function playerRank(attrUps: number, skillUps: number): string {
  const total = attrUps + skillUps;
  return PLAYER_RANKS[Math.min(total, PLAYER_RANKS.length - 1)];
}

function totalAttrUps(e: RosterEntryFull) {
  return e.mvUp + e.stUp + e.agUp + e.paUp + e.avUp;
}

function totalAttrUpsRow(r: EditRow) {
  return r.mvUp + r.stUp + r.agUp + r.paUp + r.avUp;
}

function formatTV(n: number) {
  return (n / 1000).toFixed(0) + 'k MO';
}

// ─── Props ────────────────────────────────────────────────────────────────────

interface Props {
  participantId: number;
  canEdit: boolean;
  onClose: () => void;
  onSaved?: () => void;
}

// ─── Main component ───────────────────────────────────────────────────────────

export default function RosterModal({ participantId, canEdit, onClose, onSaved }: Props) {
  useEffect(() => {
    document.body.classList.add('overflow-hidden');
    return () => document.body.classList.remove('overflow-hidden');
  }, []);

  const [participant, setParticipant] = useState<ParticipantFull | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [editing, setEditing] = useState(false);
  const [editRows, setEditRows] = useState<EditRow[]>([]);
  const [editRerolls, setEditRerolls] = useState(0);
  const [editApothecary, setEditApothecary] = useState(false);
  const [editCheerleaders, setEditCheerleaders] = useState(0);
  const [editAssistantCoaches, setEditAssistantCoaches] = useState(0);
  const [editFanFactor, setEditFanFactor] = useState(0);
  const [editMatchGold, setEditMatchGold] = useState(0);
  const [editTeamName, setEditTeamName] = useState('');
  const [saving, setSaving] = useState(false);

  const [positions, setPositions] = useState<Position[]>([]);
  const [allSkills, setAllSkills] = useState<Skill[]>([]);
  const [loadingRef, setLoadingRef] = useState(false);

  useEffect(() => {
    participantsApi.getById(participantId)
      .then((p) => setParticipant(p as unknown as ParticipantFull))
      .catch((e) => setError(e instanceof Error ? e.message : 'Error al cargar ficha'))
      .finally(() => setLoading(false));
  }, [participantId]);

  const enterEdit = async () => {
    if (!participant) return;
    setLoadingRef(true);
    try {
      const [pos, skills] = await Promise.all([
        reference.getRacePositions(participant.race.id),
        reference.getSkills(),
      ]);
      setPositions(pos);
      setAllSkills(skills);
      setEditRerolls(participant.rerolls);
      setEditApothecary(participant.hasApothecary);
      setEditCheerleaders(participant.cheerleaders ?? 0);
      setEditAssistantCoaches(participant.assistantCoaches ?? 0);
      setEditFanFactor(participant.fanFactor ?? 0);
      setEditMatchGold(0);
      setEditTeamName(participant.teamName ?? '');
      setEditRows(participant.roster.map((e) => ({
        positionId: e.positionId,
        dorsal: e.dorsal != null ? String(e.dorsal) : '',
        playerName: e.playerName ?? '',
        spp: e.spp,
        injured: e.injured ?? false,
        additionalSkillIds: e.skills.map((s) => s.skill.id),
        mvUp: e.mvUp ?? 0,
        stUp: e.stUp ?? 0,
        agUp: e.agUp ?? 0,
        paUp: e.paUp ?? 0,
        avUp: e.avUp ?? 0,
        positionName: e.position.name,
        ma: e.position.ma, st: e.position.st, ag: e.position.ag,
        pa: e.position.pa, av: e.position.av,
        baseSkills: e.position.skills.map((ps) => ps.skill.name),
        cost: e.position.cost,
      })));
      setEditing(true);
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Error al cargar datos de edición');
    } finally {
      setLoadingRef(false);
    }
  };

  const handleSave = async () => {
    if (!participant) return;
    setSaving(true);
    try {
      const roster = editRows
        .filter((r) => r.positionId !== null)
        .map((r) => ({
          positionId: r.positionId!,
          dorsal: r.dorsal.trim() !== '' ? Number(r.dorsal) : undefined,
          playerName: r.playerName.trim() || undefined,
          spp: r.spp,
          injured: r.injured,
          skillIds: r.additionalSkillIds,
          mvUp: r.mvUp,
          stUp: r.stUp,
          agUp: r.agUp,
          paUp: r.paUp,
          avUp: r.avUp,
        }));
      await participantsApi.updateRoster(participantId, roster, editRerolls, editApothecary, editTeamName, editCheerleaders, editAssistantCoaches, editFanFactor, undefined, editMatchGold || undefined);
      const updated = await participantsApi.getById(participantId);
      setParticipant(updated as unknown as ParticipantFull);
      setEditing(false);
      onSaved?.();
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Error al guardar ficha');
    } finally {
      setSaving(false);
    }
  };

  const addRow = () => {
    setEditRows((prev) => [...prev, {
      positionId: null, dorsal: '', playerName: '', spp: 0, injured: false,
      additionalSkillIds: [], mvUp: 0, stUp: 0, agUp: 0, paUp: 0, avUp: 0,
      positionName: '', ma: 0, st: 0, ag: 0, pa: null, av: 0, baseSkills: [], cost: 0,
    }]);
  };

  const removeRow = (i: number) => setEditRows((prev) => prev.filter((_, idx) => idx !== i));

  const updateRow = (i: number, patch: Partial<EditRow>) =>
    setEditRows((prev) => prev.map((r, idx) => idx === i ? { ...r, ...patch } : r));

  const handlePositionChange = (i: number, posId: string) => {
    const pos = positions.find((p) => p.id === Number(posId));
    if (!pos) { updateRow(i, { positionId: null, positionName: '', ma: 0, st: 0, ag: 0, pa: null, av: 0, baseSkills: [], cost: 0 }); return; }
    updateRow(i, {
      positionId: pos.id, positionName: pos.name,
      ma: pos.ma, st: pos.st, ag: pos.ag, pa: pos.pa, av: pos.av,
      baseSkills: pos.skills.map((ps) => ps.skill.name),
      cost: pos.cost,
    });
  };

  const toggleSkill = (rowIdx: number, skillId: number) => {
    const row = editRows[rowIdx];
    const ids = row.additionalSkillIds.includes(skillId)
      ? row.additionalSkillIds.filter((id) => id !== skillId)
      : [...row.additionalSkillIds, skillId];
    updateRow(rowIdx, { additionalSkillIds: ids });
  };

  const editTV = editRows.filter(r => r.cost && !r.injured).reduce((s, r) => s + r.cost + upgradeTV(r), 0)
    + editRerolls * (participant?.race.rerollCost ?? 0)
    + (editApothecary ? 50000 : 0)
    + editCheerleaders * 10000
    + editAssistantCoaches * 10000;

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center p-2 pt-4 sm:p-4 sm:pt-8 overflow-y-auto">
      <div className="fixed inset-0 bg-black/40 backdrop-blur-sm" onClick={onClose} />

      <div className="relative w-full max-w-4xl bg-white rounded-2xl shadow-xl border border-black/8 mb-8 overflow-hidden">

        {/* ── Header ── */}
        <div className="flex items-start justify-between gap-4 px-6 py-5 border-b border-black/8">
          <div className="min-w-0">
            {loading ? (
              <div className="space-y-2">
                <div className="h-5 w-48 bg-black/8 rounded animate-pulse" />
                <div className="h-3.5 w-32 bg-black/5 rounded animate-pulse" />
              </div>
            ) : participant ? (
              <>
                <div className="flex items-center gap-2.5 flex-wrap">
                  <h2 className="font-display text-xl font-bold text-parchment-100 leading-tight">
                    {participant.teamName ?? participant.player.name}
                  </h2>
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full leading-none border ${
                    participant.isVeteran
                      ? 'bg-terracota-400/10 text-terracota-400 border-terracota-400/20'
                      : 'bg-verde-500/10 text-verde-500 border-verde-500/20'
                  }`}>
                    {participant.isVeteran ? 'Veterano' : 'Novato'}
                  </span>
                </div>
                <p className="text-parchment-400 text-sm mt-1">
                  {participant.player.name}
                  <span className="mx-1.5 text-parchment-400/40">·</span>
                  <span className="text-parchment-300">{participant.race.name}</span>
                </p>
              </>
            ) : null}
          </div>
          <button
            onClick={onClose}
            className="shrink-0 w-7 h-7 flex items-center justify-center rounded-full text-parchment-400 hover:text-parchment-100 hover:bg-black/6 transition-colors text-lg leading-none mt-0.5"
          >
            ×
          </button>
        </div>

        <div className="px-6 py-5">
          {loading && <p className="text-parchment-400 text-sm py-4 text-center">Cargando ficha…</p>}
          {error && <p className="text-dragon-400 text-sm">{error}</p>}

          {participant && !loading && (
            <>
              {/* ── Stats panel ── */}
              {!editing ? (
                <ViewStats participant={participant} />
              ) : (
                <EditControls
                  editTeamName={editTeamName} setEditTeamName={setEditTeamName}
                  editRerolls={editRerolls} setEditRerolls={setEditRerolls}
                  editApothecary={editApothecary} setEditApothecary={setEditApothecary}
                  editCheerleaders={editCheerleaders} setEditCheerleaders={setEditCheerleaders}
                  editAssistantCoaches={editAssistantCoaches} setEditAssistantCoaches={setEditAssistantCoaches}
                  editFanFactor={editFanFactor} setEditFanFactor={setEditFanFactor}
                  editMatchGold={editMatchGold} setEditMatchGold={setEditMatchGold}
                  editTV={editTV}
                />
              )}

              {/* ── Roster — view mode ── */}
              {!editing && (
                <div className="mt-5">
                  {participant.roster.length === 0 ? (
                    <div className="py-8 text-center border border-dashed border-black/10 rounded-xl">
                      <p className="text-parchment-400 text-sm italic">Sin ficha registrada.</p>
                    </div>
                  ) : (
                    <div className="overflow-x-auto rounded-xl border border-black/8">
                      <table className="w-full text-xs">
                        <thead>
                          <tr className="bg-black/[0.025] border-b border-black/8 text-parchment-400">
                            <th className="px-3 py-2.5 text-left w-10 font-medium">Dorsal</th>
                            <th className="px-3 py-2.5 text-left font-medium">Nombre</th>
                            <th className="px-3 py-2.5 text-left font-medium">Posición</th>
                            <Th tooltip="Movimiento" className="px-2 py-2.5 w-9 font-medium">MA</Th>
                            <Th tooltip="Fuerza" className="px-2 py-2.5 w-9 font-medium">ST</Th>
                            <Th tooltip="Agilidad" className="px-2 py-2.5 w-9 font-medium">AG</Th>
                            <Th tooltip="Pase" className="px-2 py-2.5 w-9 font-medium">PA</Th>
                            <Th tooltip="Armadura" className="px-2 py-2.5 w-9 font-medium">AV</Th>
                            <th className="px-3 py-2.5 text-left font-medium">Habilidades</th>
                            <th className="px-2 py-2.5 w-10 text-center font-medium">PE</th>
                            <th className="px-3 py-2.5 text-left font-medium">Estado</th>
                          </tr>
                        </thead>
                        <tbody>
                          {[...participant.roster].sort((a, b) => {
                            if (a.dorsal == null && b.dorsal == null) return 0;
                            if (a.dorsal == null) return 1;
                            if (b.dorsal == null) return -1;
                            return a.dorsal - b.dorsal;
                          }).map((e, i) => {
                            const allSkills = [
                              ...e.position.skills.map((ps) => ps.skill.name),
                              ...e.skills.map((s) => s.skill.name),
                            ];
                            const rank = playerRank(totalAttrUps(e), e.skills.length);
                            return (
                              <tr
                                key={e.id}
                                className={`border-b border-black/5 last:border-0 transition-colors ${
                                  e.injured
                                    ? 'bg-dragon-400/4 opacity-60'
                                    : i % 2 === 1 ? 'bg-black/[0.015]' : ''
                                }`}
                              >
                                <td className="px-3 py-2.5 font-mono font-bold text-parchment-300">
                                  {e.dorsal != null ? e.dorsal : <span className="text-parchment-400/30">—</span>}
                                </td>
                                <td className="px-3 py-2.5">
                                  <div className="font-medium text-parchment-100">
                                    {e.playerName ?? <span className="text-parchment-400/40 italic font-normal">—</span>}
                                  </div>
                                  {rank && <div className="text-[10px] text-terracota-400 font-semibold mt-0.5">{rank}</div>}
                                </td>
                                <td className="px-3 py-2.5 text-parchment-300">{e.position.name}</td>
                                <td className="px-2 py-2.5 text-center"><StatCell base={e.position.ma} up={e.mvUp} /></td>
                                <td className="px-2 py-2.5 text-center"><StatCell base={e.position.st} up={e.stUp} /></td>
                                <td className="px-2 py-2.5 text-center"><StatCell base={e.position.ag} up={e.agUp} /></td>
                                <td className="px-2 py-2.5 text-center"><StatCell base={e.position.pa} up={e.paUp} nullable /></td>
                                <td className="px-2 py-2.5 text-center"><StatCell base={e.position.av} up={e.avUp} /></td>
                                <td className="px-3 py-2.5">
                                  <div className="flex flex-wrap gap-1">
                                    {allSkills.length === 0
                                      ? <span className="text-parchment-400/30">—</span>
                                      : allSkills.map((s) => (
                                        <span key={s} className="bg-black/6 text-parchment-300 px-1.5 py-0.5 rounded text-[10px]">{s}</span>
                                      ))
                                    }
                                  </div>
                                </td>
                                <td className="px-2 py-2.5 text-center">
                                  <span className={`font-mono font-bold ${e.spp > 0 ? 'text-verde-500' : 'text-parchment-400/30'}`}>{e.spp}</span>
                                </td>
                                <td className="px-3 py-2.5">
                                  {e.injured
                                    ? <span className="bg-dragon-400/10 text-dragon-500 border border-dragon-400/20 px-1.5 py-0.5 rounded text-[10px] font-semibold">Lesionado</span>
                                    : <span className="text-parchment-400/30">—</span>
                                  }
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  )}

                  {canEdit && (
                    <div className="mt-4">
                      <button onClick={enterEdit} disabled={loadingRef} className="btn-secondary text-xs">
                        {loadingRef ? 'Cargando…' : '✎ Editar ficha'}
                      </button>
                    </div>
                  )}
                </div>
              )}

              {/* ── Roster — edit mode ── */}
              {editing && (
                <div className="mt-5 space-y-4">
                  <div className="overflow-x-auto rounded-xl border border-black/8">
                    <table className="table-fixed text-xs" style={{ minWidth: '840px' }}>
                      <colgroup>
                        <col style={{ width: '52px' }} />
                        <col style={{ width: '130px' }} />
                        <col style={{ width: '150px' }} />
                        <col style={{ width: '52px' }} />
                        <col style={{ width: '52px' }} />
                        <col style={{ width: '210px' }} />
                        <col style={{ width: '180px' }} />
                        <col style={{ width: '24px' }} />
                      </colgroup>
                      <thead>
                        <tr className="bg-black/[0.025] border-b border-black/8 text-parchment-400">
                          <th className="px-3 py-2.5 text-left font-medium">Dorsal</th>
                          <th className="px-3 py-2.5 text-left font-medium">Nombre</th>
                          <th className="px-3 py-2.5 text-left font-medium">Posición</th>
                          <th className="px-2 py-2.5 text-left font-medium">PE</th>
                          <Th tooltip="Marcar si el jugador está lesionado — no cuenta para el valor del equipo" align="center" className="px-2 py-2.5 font-medium">Lesión</Th>
                          <Th tooltip="Mejoras de atributo: MA +20k · ST +60k · AG +30k · PA +20k · AV +10k" align="left" className="px-3 py-2.5 font-medium">Mejoras</Th>
                          <Th tooltip="Habilidades adicionales adquiridas durante el torneo" align="left" className="px-3 py-2.5 font-medium">Habilidades extra</Th>
                          <th className="py-2.5" />
                        </tr>
                      </thead>
                      <tbody>
                        {editRows.map((row, i) => (
                          <EditRowComponent
                            key={i}
                            row={row}
                            idx={i}
                            positions={positions}
                            allSkills={allSkills}
                            onPositionChange={handlePositionChange}
                            onUpdate={updateRow}
                            onRemove={removeRow}
                            onToggleSkill={toggleSkill}
                          />
                        ))}
                      </tbody>
                    </table>
                  </div>

                  {editRows.length < 16 && (
                    <button type="button" onClick={addRow}
                      className="text-xs text-verde-500 hover:text-verde-400 border border-verde-500/30 hover:border-verde-500/60 rounded-lg px-3 py-1.5 transition-colors font-medium">
                      + Fichar jugador
                    </button>
                  )}

                  {error && <p className="text-dragon-400 text-xs">{error}</p>}

                  <div className="flex gap-2 pt-3 border-t border-black/8">
                    <button onClick={handleSave} disabled={saving} className="btn-primary text-xs">
                      {saving ? 'Guardando…' : 'Guardar cambios'}
                    </button>
                    <button onClick={() => setEditing(false)} className="btn-secondary text-xs">
                      Cancelar
                    </button>
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    </div>
  );
}

// ─── View stats panel ─────────────────────────────────────────────────────────

function ViewStats({ participant }: { participant: ParticipantFull }) {
  return (
    <div className="bg-black/[0.025] rounded-xl border border-black/8 p-4">
      {/* Top row: TV + Treasury */}
      <div className="flex items-end gap-6 mb-3 pb-3 border-b border-black/8">
        <div>
          <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-0.5">Valor de equipo</p>
          <p className="font-display text-2xl font-bold text-verde-500 leading-none">{formatTV(participant.teamValue)}</p>
        </div>
        <div>
          <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-0.5">Tesorería</p>
          <p className="font-display text-lg font-bold text-terracota-400 leading-none">{formatTV(participant.treasury ?? 1000000)}</p>
        </div>
        <div className="ml-auto text-right">
          <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-0.5">Jugadores</p>
          <p className="font-display text-lg font-bold text-parchment-200 leading-none">{participant.roster.length}</p>
        </div>
      </div>

      {/* Bottom row: staff details */}
      <div className="flex flex-wrap gap-x-5 gap-y-1.5">
        <StaffChip label="Re-rolls" value={String(participant.rerolls)} />
        <StaffChip label="Apotecario" value={participant.hasApothecary ? 'Sí' : 'No'} />
        <StaffChip label="Animadoras" value={String(participant.cheerleaders ?? 0)} />
        <StaffChip label="2º Entrenadores" value={String(participant.assistantCoaches ?? 0)} />
        <StaffChip label="Factor hinchas" value={String(participant.fanFactor ?? 0)} />
      </div>
    </div>
  );
}

function StaffChip({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center gap-1.5 text-xs">
      <span className="text-parchment-400">{label}:</span>
      <span className="font-semibold text-parchment-200">{value}</span>
    </div>
  );
}

// ─── Edit controls panel ──────────────────────────────────────────────────────

function EditControls({
  editTeamName, setEditTeamName,
  editRerolls, setEditRerolls,
  editApothecary, setEditApothecary,
  editCheerleaders, setEditCheerleaders,
  editAssistantCoaches, setEditAssistantCoaches,
  editFanFactor, setEditFanFactor,
  editMatchGold, setEditMatchGold,
  editTV,
}: {
  editTeamName: string; setEditTeamName: (v: string) => void;
  editRerolls: number; setEditRerolls: (v: number) => void;
  editApothecary: boolean; setEditApothecary: (v: boolean) => void;
  editCheerleaders: number; setEditCheerleaders: (v: number) => void;
  editAssistantCoaches: number; setEditAssistantCoaches: (v: number) => void;
  editFanFactor: number; setEditFanFactor: (v: number) => void;
  editMatchGold: number; setEditMatchGold: (v: number) => void;
  editTV: number;
}) {
  const numCls = 'w-14 bg-white border border-black/15 focus:border-verde-500 text-parchment-100 text-center rounded-lg px-1 py-1.5 text-sm outline-none transition-colors';

  return (
    <div className="bg-black/[0.025] rounded-xl border border-black/8 p-4 space-y-4">

      {/* TV preview */}
      <div className="flex items-center justify-between">
        <div>
          <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-0.5">Valor de equipo</p>
          <p className="font-display text-2xl font-bold text-verde-500 leading-none">{formatTV(editTV)}</p>
        </div>
      </div>

      <div className="border-t border-black/8" />

      {/* Identidad */}
      <div>
        <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-2">Identidad</p>
        <div className="flex items-center gap-2">
          <label className="text-xs text-parchment-400 shrink-0">Nombre del equipo</label>
          <input
            type="text"
            value={editTeamName}
            onChange={(e) => setEditTeamName(e.target.value)}
            placeholder="Opcional"
            className="flex-1 bg-white border border-black/15 focus:border-verde-500 text-parchment-100 rounded-lg px-3 py-1.5 text-sm outline-none transition-colors placeholder:text-parchment-400/50"
          />
        </div>
      </div>

      <div className="border-t border-black/8" />

      {/* Staff */}
      <div>
        <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-3">Staff</p>
        <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
          <FieldPair label="Re-rolls">
            <input type="number" min={0} max={8} value={editRerolls}
              onChange={(e) => setEditRerolls(Math.max(0, Math.min(8, Number(e.target.value))))}
              className={numCls} />
          </FieldPair>
          <FieldPair label="Animadoras">
            <input type="number" min={0} max={6} value={editCheerleaders}
              onChange={(e) => setEditCheerleaders(Math.min(6, Math.max(0, Number(e.target.value))))}
              className={numCls} />
          </FieldPair>
          <FieldPair label="2º Entrenadores">
            <input type="number" min={0} max={6} value={editAssistantCoaches}
              onChange={(e) => setEditAssistantCoaches(Math.min(6, Math.max(0, Number(e.target.value))))}
              className={numCls} />
          </FieldPair>
          <label className="flex items-center gap-2 cursor-pointer select-none">
            <input type="checkbox" checked={editApothecary}
              onChange={(e) => setEditApothecary(e.target.checked)}
              className="w-4 h-4 accent-verde-500 cursor-pointer rounded" />
            <span className="text-sm text-parchment-300 font-medium">Apotecario</span>
          </label>
        </div>
      </div>

      <div className="border-t border-black/8" />

      {/* Partido actual */}
      <div>
        <p className="text-[10px] uppercase tracking-wider text-parchment-400 font-semibold mb-3">Partido actual</p>
        <div className="flex flex-wrap items-center gap-x-5 gap-y-3">
          <FieldPair label="Factor de hinchas">
            <input type="number" min={0} max={7} value={editFanFactor}
              onChange={(e) => setEditFanFactor(Math.min(7, Math.max(0, Number(e.target.value))))}
              className={numCls} />
          </FieldPair>
          <FieldPair label="Oro ganado (MO)">
            <input type="number" min={0} step={1000} value={editMatchGold}
              onChange={(e) => setEditMatchGold(Math.max(0, Number(e.target.value)))}
              className="w-24 bg-white border border-verde-500/40 focus:border-verde-500 text-verde-500 font-bold text-center rounded-lg px-2 py-1.5 text-sm outline-none transition-colors" />
          </FieldPair>
        </div>
      </div>
    </div>
  );
}

function FieldPair({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="flex items-center gap-2">
      <span className="text-xs text-parchment-400 whitespace-nowrap">{label}</span>
      {children}
    </div>
  );
}

// ─── Stat cell con mejora ─────────────────────────────────────────────────────

function StatCell({ base, up, nullable }: { base: number | null; up: number; nullable?: boolean }) {
  if (nullable && base === null) return <span className="text-parchment-400/40">—</span>;
  const effective = (base ?? 0) + up;
  return up > 0
    ? <span className="text-verde-500 font-bold">{effective}<sup className="text-[9px] ml-0.5 font-normal">+{up}</sup></span>
    : <span className="text-parchment-200">{effective}</span>;
}

// ─── Edit row ─────────────────────────────────────────────────────────────────

function UpStepper({ label, value, onChange }: { label: string; value: number; onChange: (v: number) => void }) {
  return (
    <div className="flex items-center gap-0.5">
      <span className="text-parchment-400 w-5 text-[10px] font-medium">{label}</span>
      <button type="button" onClick={() => onChange(Math.max(0, value - 1))}
        className="w-5 h-5 flex items-center justify-center text-parchment-400 hover:text-dragon-500 bg-black/5 hover:bg-dragon-400/10 rounded text-[11px] leading-none transition-colors">−</button>
      <span className={`w-5 text-center text-[11px] font-mono font-bold ${value > 0 ? 'text-verde-500' : 'text-parchment-400/40'}`}>{value}</span>
      <button type="button" onClick={() => onChange(value + 1)}
        className="w-5 h-5 flex items-center justify-center text-parchment-400 hover:text-verde-500 bg-black/5 hover:bg-verde-500/10 rounded text-[11px] leading-none transition-colors">+</button>
    </div>
  );
}

function EditRowComponent({
  row, idx, positions, allSkills, onPositionChange, onUpdate, onRemove, onToggleSkill,
}: {
  row: EditRow;
  idx: number;
  positions: Position[];
  allSkills: Skill[];
  onPositionChange: (i: number, posId: string) => void;
  onUpdate: (i: number, patch: Partial<EditRow>) => void;
  onRemove: (i: number) => void;
  onToggleSkill: (rowIdx: number, skillId: number) => void;
}) {
  const [showSkillPicker, setShowSkillPicker] = useState(false);

  const rank = playerRank(totalAttrUpsRow(row), row.additionalSkillIds.length);

  const inputCls = 'bg-white border border-black/12 focus:border-verde-500 text-parchment-100 rounded-lg px-2 py-1.5 text-xs outline-none transition-colors w-full';

  return (
    <tr className={`border-b border-black/5 last:border-0 transition-colors ${
      row.injured ? 'bg-dragon-400/4 opacity-60' : idx % 2 === 1 ? 'bg-black/[0.015]' : ''
    }`}>
      <td className="px-2 py-2">
        <input type="number" min={1} max={99} value={row.dorsal}
          onChange={(e) => onUpdate(idx, { dorsal: e.target.value })}
          placeholder="—"
          className="bg-white border border-black/12 focus:border-verde-500 text-parchment-100 text-center rounded-lg px-1 py-1.5 text-xs outline-none w-full" />
      </td>
      <td className="px-2 py-2">
        <input type="text" value={row.playerName}
          onChange={(e) => onUpdate(idx, { playerName: e.target.value })}
          placeholder="Opcional" className={inputCls} />
      </td>
      <td className="px-2 py-2">
        <select value={row.positionId ?? ''}
          onChange={(e) => onPositionChange(idx, e.target.value)}
          className={inputCls}>
          <option value="">Seleccionar…</option>
          {positions.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
        </select>
      </td>
      <td className="px-2 py-2">
        <input type="number" min={0} value={row.spp}
          onChange={(e) => onUpdate(idx, { spp: Math.max(0, Number(e.target.value)) })}
          className="bg-white border border-black/12 focus:border-verde-500 text-parchment-100 text-center rounded-lg px-1 py-1.5 text-xs outline-none w-full" />
      </td>
      <td className="px-2 py-2 text-center">
        <input
          type="checkbox"
          checked={row.injured}
          onChange={(e) => onUpdate(idx, { injured: e.target.checked })}
          className="w-4 h-4 accent-dragon-400 cursor-pointer"
        />
      </td>
      <td className="px-3 py-2">
        <div className="flex flex-wrap gap-x-3 gap-y-1.5">
          <UpStepper label="MA" value={row.mvUp} onChange={(v) => onUpdate(idx, { mvUp: v })} />
          <UpStepper label="ST" value={row.stUp} onChange={(v) => onUpdate(idx, { stUp: v })} />
          <UpStepper label="AG" value={row.agUp} onChange={(v) => onUpdate(idx, { agUp: v })} />
          <UpStepper label="PA" value={row.paUp} onChange={(v) => onUpdate(idx, { paUp: v })} />
          <UpStepper label="AV" value={row.avUp} onChange={(v) => onUpdate(idx, { avUp: v })} />
        </div>
      </td>
      <td className="px-3 py-2 relative">
        <div className="flex flex-wrap gap-1 items-center">
          {row.additionalSkillIds.map((id) => {
            const skill = allSkills.find((s) => s.id === id);
            return skill ? (
              <span key={id} className="bg-verde-500/10 text-verde-500 border border-verde-500/20 px-1.5 py-0.5 rounded text-[10px] flex items-center gap-1 font-medium">
                {skill.name}
                <button type="button" onClick={() => onToggleSkill(idx, id)}
                  className="text-verde-400/60 hover:text-dragon-500 leading-none transition-colors">×</button>
              </span>
            ) : null;
          })}
          <button type="button" onClick={() => setShowSkillPicker(!showSkillPicker)}
            className="text-parchment-400 hover:text-verde-500 text-xs border border-black/12 hover:border-verde-500/40 rounded px-1.5 py-0.5 transition-colors bg-white">
            + Skill
          </button>
        </div>
        {showSkillPicker && (
          <div className="absolute top-full left-0 z-30 mt-1 bg-white border border-black/12 rounded-xl shadow-lg max-h-48 overflow-y-auto w-52">
            {allSkills.filter((s) => !row.additionalSkillIds.includes(s.id)).map((s) => (
              <button key={s.id} type="button"
                onClick={() => { onToggleSkill(idx, s.id); setShowSkillPicker(false); }}
                className="w-full text-left px-3 py-2 text-xs text-parchment-300 hover:bg-verde-500/5 hover:text-parchment-100 transition-colors flex items-center justify-between gap-2">
                <span className="font-medium text-parchment-100">{s.name}</span>
                <span className="text-parchment-400/50 text-[10px] shrink-0">{s.category}</span>
              </button>
            ))}
          </div>
        )}
      </td>
      <td className="px-2 py-2">
        <button type="button" onClick={() => onRemove(idx)}
          className="w-5 h-5 flex items-center justify-center text-parchment-400/40 hover:text-dragon-500 hover:bg-dragon-400/8 rounded transition-colors text-sm leading-none">
          ×
        </button>
      </td>
    </tr>
  );
}
