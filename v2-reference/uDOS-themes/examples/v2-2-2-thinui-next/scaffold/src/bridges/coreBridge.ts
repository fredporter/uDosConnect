import type { ThinUiEvent, ThinUiStatePacket } from "../contracts/thinui";

export interface CoreBridge {
  hydrate(): Promise<ThinUiStatePacket>;
  dispatch(event: ThinUiEvent): Promise<void>;
}
