import { Router, type IRouter } from "express";
import healthRouter from "./health";
import waitlistConfirmRouter from "./waitlist-confirm";
import notifyCoachRouter from "./notify-coach";

const router: IRouter = Router();

router.use(healthRouter);
router.use(waitlistConfirmRouter);
router.use(notifyCoachRouter);

export default router;
