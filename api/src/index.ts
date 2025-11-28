import express, { Request, Response } from "express";
import cors from "cors";
import { onRequest } from "firebase-functions/v2/https";

// Express 앱 생성
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// ---------------------------------------------------------
// POST /api/trips → 새 여행 등록
// ---------------------------------------------------------
app.post("/trips", async (req: Request, res: Response) => {
  try {
    const {
      title,
      country,
      city,
      startDate,
      endDate,
      travelerCount,
      budget,
      theme,
      purpose,
      lodgingTypes,
      transportModes,
    } = req.body;

    if (!title || !country || !city || !startDate || !endDate) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const newTrip = {
      id: "trp_" + Date.now(),
      title,
      country,
      city,
      startDate,
      endDate,
      travelerCount: travelerCount ?? 1,
      budget: budget ?? null,
      theme: theme ?? null,
      purpose,
      lodgingTypes,
      transportModes,
      createdAt: new Date().toISOString(),
    };

    console.log("📌 [Functions] Trip created:", newTrip);

    return res.status(201).json({
      message: "Trip created successfully",
      trip: newTrip,
    });
  } catch (err) {
    console.error("🔥 Error:", err);
    return res.status(500).json({ error: "Internal Server Error" });
  }
});

// ---------------------------------------------------------
// Firebase Functions로 Export (v2 방식)
// ---------------------------------------------------------
export const api = onRequest(
  {
    region: "asia-northeast3",
    maxInstances: 10,
  },
  app
);
