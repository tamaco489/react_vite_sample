import { DefaultOptions, QueryClient } from "@tanstack/react-query";

import type { Error } from "@/lib/fetch";
import storage from "@/utils/storage";

const queryConfig: DefaultOptions<Error<{ statusCode: number }>> = {
  queries: {
    throwOnError(error) {
      // 500エラーは例外エラーとしてキャッチさせる
      if (!error.response) return true;
      if (error.response?.data.statusCode === 401) {
        storage.clearToken();
        return true;
      }
      return error.response?.status >= 500;
    },
    refetchOnWindowFocus: false,
    retry: false,
  },
  mutations: {
    throwOnError(error) {
      // 500エラーは例外エラーとしてキャッチさせる
      if (!error.response) return true;
      if (error.response?.data.statusCode === 401) {
        storage.clearToken();
        return true;
      }
      return error.response?.status >= 500;
    },
  },
};

export const queryClient = new QueryClient({
  defaultOptions: queryConfig as unknown as DefaultOptions,
});
