import { Loader2 } from "lucide-react";
import { Suspense } from "react";
import { Outlet, RouteObject } from "react-router";
import { useRouteError } from "react-router";

import { Error } from "@/components/error";
import { MainLayout } from "@/components/layout";
import { useAuth } from "@/lib/auth0";
import { HomePage } from "@/pages/home";

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

// エラー時の画面表示
export const ErrorBoundary = () => {
  const error = useRouteError();
  const { login } = useAuth();
  // apiで認証エラーが起きた時
  if ((error as { response: { status: number } }).response?.status === 401) {
    // useAuthのuser stateが残るためリロードし消す
    location.reload();
    // リロードはすぐにされないので、ローディングを表示する
    return (
      <div className="flex h-screen items-center justify-center">
        <Loader2 className="animate-spin" />
      </div>
    );
  }
  // useAuthのuser stateがない時
  // ログインしていない状態で保護されたページにアクセスした時
  if ((error as Error).message === "401") {
    // ログインを実行
    login();
    // ログイン中のローディングを表示
    return (
      <div className="flex h-screen items-center justify-center">
        <Loader2 className="animate-spin" />
      </div>
    );
  }
  // それ以外はエラー
  return <Error />;
};

/**
 * ログインしないと見れないページ
 */
export const getProtectedRoutes = (): RouteObject[] => {
  const { login, isLoading, isAuthenticated, error } = useAuth();
  return [
    {
      path: "/",
      element: <App />,
      children: [
        {
          errorElement: <ErrorBoundary />,
          loader: async () => {
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
            return null;
          },
          children: [
            { path: "home", element: <HomePage /> },
            { path: "users", element: <div>userページ</div> },
          ],
        },
      ],
    },
  ];
};
