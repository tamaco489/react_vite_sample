import { fetchClient } from "@/lib/fetch";

export type FetchAccountResponse = {
  accessToken: string;
};

export const fetchAccount = () => {
  return fetchClient.get<FetchAccountResponse>("/api/v1/users/me");
};

// apiのURLと合わせること
export const queryKey = ["api", "v1", "users", "me"];
