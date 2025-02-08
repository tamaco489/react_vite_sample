import { Loader2 } from "lucide-react";
import { Suspense } from "react";
import { Outlet, RouteObject } from "react-router";

import { Error } from "@/components/error";
import { MainLayout } from "@/components/layout";

const App = () => {
  return (
    <MainLayout>
      <Suspense
        fallback={
          <div className="flex h-screen items-center justify-center">
            <Loader2 className="animate-spin" />
          </div>
        }
      >
        <Outlet />
      </Suspense>
    </MainLayout>
  );
};

/**
 * ログインしていない時でもみれるページ一覧
 */
export const getPublicRoutes = (): RouteObject[] => {
  return [
    {
      path: "/",
      element: <App />,
      errorElement: (
        <Error message="予期せぬエラーが発生しました。" status="500" />
      ),
      children: [
        {
          errorElement: <Error />,
          children: [
            // 以下のようにルーティングを設定する
            // { path: "login", element: <LoginPage /> }
          ],
        },
      ],
    },
  ];
};
