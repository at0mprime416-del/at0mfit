import { Router, type IRouter } from "express";
import healthRouter from "./health";
import waitlistConfirmRouter from "./waitlist-confirm";
import notifyCoachRouter from "./notify-coach";
import askAtomRouter from "./ask-atom";

const router: IRouter = Router();

router.use(healthRouter);
router.use(waitlistConfirmRouter);
router.use(notifyCoachRouter);
router.use(askAtomRouter);

export default router;
