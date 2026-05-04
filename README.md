# Liga Blood Bowl — El Dragón de Madera

Plataforma web de gestión de torneos de Blood Bowl para la asociación **El Dragón de Madera**. Permite crear torneos, inscribir jugadores, registrar fichas de equipo y seguir clasificaciones en tiempo real.

Sin autenticación — cualquier visitante puede leer y escribir datos.

## Stack

| Capa | Tecnología |
|---|---|
| Frontend | React 18 + Vite + TypeScript + Tailwind CSS |
| Backend | Node.js + Express + TypeScript |
| Base de datos | PostgreSQL vía Prisma ORM |
| Scraper | Axios + Cheerio (datos de razas desde nufflezone.com) |
| Deploy | Vercel (frontend) + Render (backend) + Neon (PostgreSQL) |

## Estructura

```
liga-bloodbowl/
├── prisma/schema.prisma      # Esquema PostgreSQL
├── scripts/scraper.ts        # Scraper de razas, posiciones y habilidades
├── backend/src/
│   ├── server.ts
│   ├── routes/               # tournaments, players, matches, participants, reference, stats
│   └── lib/                  # bracket.ts, standings.ts, validation.ts
└── frontend/src/
    ├── pages/
    ├── components/bracket/
    └── api/client.ts
```

## Puesta en marcha

### Requisitos

- Node.js 18+
- PostgreSQL (o cuenta en Neon)

### Variables de entorno

Crea un archivo `.env` en la raíz:

```env
DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/bloodbowl"
PORT=3001
```

### Instalación

```bash
npm install
npm run prisma:migrate
npm run scraper        # Obligatorio antes del primer uso — pobla razas, posiciones y habilidades
```

### Desarrollo

```bash
npm run dev:backend    # http://localhost:3001
npm run dev:frontend   # http://localhost:5173
```

### Producción

```bash
npm run build:frontend
```

Despliega `frontend/dist/` como estáticos y el backend como servicio Node.js. El frontend llama a `/api/*` que debe ser proxiado al backend (puerto 3001).

## Formatos de torneo

| Formato | Descripción |
|---|---|
| `MIXED` | Fase de grupos (round-robin) + eliminatoria cruzada |
| `ROUND_ROBIN` | Solo fase de grupos |
| `SINGLE_ELIMINATION` | Solo eliminatoria directa |

### Flujo bracket mixto

1. `POST /api/tournaments/:id/generate-bracket` — genera grupos y jornadas
2. Jugar todos los partidos de grupo
3. `POST /api/tournaments/:id/generate-elimination` — genera bracket eliminatorio con los clasificados

## API — Endpoints principales

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/api/tournaments/:id/standings` | Clasificación calculada al vuelo |
| POST | `/api/tournaments/:id/generate-bracket` | Genera fase de grupos |
| POST | `/api/tournaments/:id/generate-elimination` | Genera bracket eliminatorio |
| POST | `/api/matches/:id/result` | Registra resultado (torneo ACTIVE) |
| PUT | `/api/participants/:id/roster` | Actualiza ficha (guarda historial) |
| GET | `/api/reference/races` | Razas y posiciones del scraper |
| GET | `/api/stats/global` | Ranking histórico global |

## Notas

- La clasificación no persiste en BD — se recalcula en cada petición desde `standings.ts`
- El scraper debe ejecutarse al menos una vez; sin datos de referencia la API devuelve HTTP 503
- Cada actualización de ficha genera un snapshot en `RosterHistory`
