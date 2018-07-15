import { Request, Response, NextFunction } from 'express'
import pg from '../setup/database'


export async function health(req: Request, res: Response, next: NextFunction) {
    return res.status(200).json({ server: "leaderboard" })
}

export async function addEntry(req: Request, res: Response, next: NextFunction) {
    const { game, type, nickname, score } = req.body

    if (!game || !nickname || !score || !type) {
        return res.status(400).json({ error: 'WrongBody' })
    }

    await pg
        .from(game)
        .insert({ nickname, type, score })
    return res.status(200).end()
}

export async function getEntry(req: Request, res: Response, next: NextFunction) {
    const { game, type, nickname, limit } = req.query

    if (!game || !nickname || !type || !limit) {
        return res.status(400).json({ error: 'WrongQuery' })
    }

    const userEntries = await pg
        .from(game)
        .select('score', 'added')
        .where({ game, type, nickname })
        .orderBy('score', 'desc')
        .limit(limit)
    return res.status(200).json({ userEntries })
}

export async function getTopEntries(req: Request, res: Response, next: NextFunction) {
    const { game, type, limit } = req.query

    if (!game || !type || !limit) {
        return res.status(400).json({ error: 'WrongQuery' })
    }

    const topEntries = await pg
        .from(game)
        .select('nickname', 'score', 'type')
        .where({ type })
        .orderBy('score', 'desc')
        .limit(limit)
    return res.status(200).json({ topEntries })
}
