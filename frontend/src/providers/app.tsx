import { Auth0Provider } from "@auth0/auth0-react";
import { QueryClientProvider } from "@tanstack/react-query";
import { Loader2 } from "lucide-react";
import * as React from "react";
import { RouterProvider } from "react-router";
import { ToastContainer } from "react-toastify";

import { AUTH0_CONFIG } from "@/config";
import { queryClient } from "@/lib/react-query";
import { getAppRoutes } from "@/routes";

/**
 * アプリケーション全体のProvider
 */
export const AppProvider = () => {
  return (
    <>
      <React.Suspense
        fallback={
          <div className="flex h-screen items-center justify-center">
            <Loader2 className="animate-spin" />
          </div>
        }
      >
        <Auth0Provider
          domain={AUTH0_CONFIG.DOMAIN}
          clientId={AUTH0_CONFIG.CLIENT_ID}
          authorizationParams={{
            audience: AUTH0_CONFIG.AUDIENCE,
            redirect_uri: window.location.origin,
          }}
        >
          <QueryClientProvider client={queryClient}>
            <WrapRouterProvider />
          </QueryClientProvider>
        </Auth0Provider>
        <ToastContainer />
      </React.Suspense>
    </>
  );
};

/**
 * propsに指定したgetAppRouters()内でuseAuthを利用しているが、
 * このフックはAuthProviderコンポーネント内でしか利用できないため、Wrapする必要がある
 * そうしないとエラーになる
 */
const WrapRouterProvider = () => {
  return <RouterProvider router={getAppRoutes()} />;
};
