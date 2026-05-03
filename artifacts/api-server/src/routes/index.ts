import { Router, type IRouter } from "express";
import healthRouter from "./health";
import waitlistConfirmRouter from "./waitlist-confirm";

const router: IRouter = Router();

router.use(healthRouter);
router.use(waitlistConfirmRouter);

export default router;
