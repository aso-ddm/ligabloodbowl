-- AlterTable Participant: tesorería del club
ALTER TABLE "Participant" ADD COLUMN "treasury" INTEGER NOT NULL DEFAULT 1000000;

-- AlterTable Match: oro ganado por cada equipo en el partido
ALTER TABLE "Match" ADD COLUMN "homeGold" INTEGER;
ALTER TABLE "Match" ADD COLUMN "awayGold" INTEGER;
