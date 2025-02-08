import { Loader2 } from "lucide-react";
import { createBrowserRouter, redirect, RouteObject } from "react-router";

import { Error } from "@/components/error";
import { useAuth } from "@/lib/auth0";
import { getProtectedRoutes } from "@/routes/protected";
import { getPublicRoutes } from "@/routes/public";

/**
 * 全体のルーティングの設定
 */
export const getAppRoutes = () => {
  const { error, login, isAuthenticated, isLoading } = useAuth();
  const commonRoutes: RouteObject[] = [
    {
      path: "/",
      errorElement: (
        <Error
          status="404"
          message="このページはすでに削除されているか、URLが間違っている可能性があります。"
        />
      ),
      element: null,
      HydrateFallback: () => (
        <div className="flex h-screen items-center justify-center">
          <Loader2 className="animate-spin" />
        </div>
      ),
      loader: async () => {
        console.log(isLoading, isAuthenticated);
        if (isLoading) {
          return null;
        }
        if (!isAuthenticated) {
          await login();
        }
        if (error) {
          throw window.Error(error.name, {
            cause: error.message,
          });
        }
        return redirect("/home");
      },
    },
  ];

  const root = createBrowserRouter([
    ...commonRoutes,
    ...getPublicRoutes(),
    ...getProtectedRoutes(),
  ]);

  return root;
};
