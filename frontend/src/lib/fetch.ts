import { API_URL } from "@/config";
import { useAuth } from "@/lib/auth0";
import * as snackbar from "@/lib/toast";

export type Error<T> = {
  response: {
    status: number;
    data: T;
  };
};

export interface FetchClientConfig<T> {
  /** URL */
  url: string;
  /** HTTP method */
  method?: string;
  /** Request headers */
  headers?: Record<string, string>;
  /** Request body */
  data?: T;
  /** Query parameters */
  params?: Record<string, string | number>;
}

export interface FetchClientResponse<T> {
  /** Response data */
  data: T;
  /** HTTP status code */
  status: number;
  /** HTTP status text */
  statusText: string;
  /** Response headers */
  headers: Headers;
  /** Request configuration */
  // config: FetchClientConfig;
}

export interface FetchClient {
  request<T, U>(config: FetchClientConfig<T>): Promise<FetchClientResponse<U>>;
  get<T>(
    url: string,
    config?: Omit<FetchClientConfig<null>, "url" | "method">
  ): Promise<FetchClientResponse<T>>;
  post<T, U>(
    url: string,
    data?: T,
    config?: Omit<FetchClientConfig<U>, "url" | "method" | "data">
  ): Promise<FetchClientResponse<U>>;
  put<T, U>(
    url: string,
    data?: T,
    config?: Omit<FetchClientConfig<U>, "url" | "method" | "data">
  ): Promise<FetchClientResponse<U>>;
  delete<T, U>(
    url: string,
    config?: Omit<FetchClientConfig<T>, "url" | "method">
  ): Promise<FetchClientResponse<U>>;
}

export const fetchClient: FetchClient = {
  async request<T, U>(
    config: FetchClientConfig<T>
  ): Promise<FetchClientResponse<U>> {
    const { url, method = "GET", headers = {}, data, params } = config;
    // Construct query string for GET requests if params are provided
    const queryString = params
      ? "?" + new URLSearchParams(params as Record<string, string>).toString()
      : "";
    //
    const { getAccessTokenSilently } = useAuth();
    const token = await getAccessTokenSilently();
    //
    const fetchOptions: RequestInit = {
      method,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
        ...headers,
      },
    };
    // Add body if it's not a GET or HEAD request
    if (
      data &&
      method.toUpperCase() !== "GET" &&
      method.toUpperCase() !== "HEAD"
    ) {
      fetchOptions.body = JSON.stringify(data);
    }

    const u = API_URL + url;
    const response = await fetch(u + queryString, fetchOptions);

    try {
      const responseData = (await response.json()) as U;
      if (!response.ok) {
        throw {
          response: {
            status: response.status,
            statusText: response.statusText,
            data: responseData,
          },
        };
      }

      return {
        data: responseData,
        status: response.status,
        statusText: response.statusText,
        headers: response.headers,
      };
    } catch {
      snackbar.error(
        `エラーが発生しました。ステータスコード: ${response.status}`
      );
      return {
        data: {} as U,
        status: response.status,
        statusText: response.statusText,
        headers: response.headers,
      };
    }
  },

  get<T>(
    url: string,
    config: Omit<FetchClientConfig<null>, "url" | "method"> = {}
  ): Promise<FetchClientResponse<T>> {
    return this.request<null, T>({ ...config, url, method: "GET" });
  },

  post<T, U>(
    url: string,
    data?: T,
    config: Omit<FetchClientConfig<T>, "url" | "method" | "data"> = {}
  ): Promise<FetchClientResponse<U>> {
    return this.request<T, U>({ ...config, url, method: "POST", data });
  },

  put<T, U>(
    url: string,
    data?: T,
    config: Omit<FetchClientConfig<T>, "url" | "method" | "data"> = {}
  ): Promise<FetchClientResponse<U>> {
    return this.request<T, U>({ ...config, url, method: "PUT", data });
  },

  delete<T, U>(
    url: string,
    config: Omit<FetchClientConfig<T>, "url" | "method"> = {}
  ): Promise<FetchClientResponse<U>> {
    return this.request<T, U>({ ...config, url, method: "DELETE" });
  },
};
