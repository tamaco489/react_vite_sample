import * as React from "react";

import { Header } from "@/components/header";

type MainLayoutProps = {
  children: React.ReactNode;
};

/**
 * メインレイアウト
 * @param param0 子コンポーネント
 */
export const MainLayout = React.memo(({ children }: MainLayoutProps) => {
  return (
    <div className="flex min-h-screen flex-col">
      <Header />
      <div className="mx-auto my-[55px] w-full max-w-[1230px] flex-1">
        <main>{children}</main>
      </div>
      <footer>copy light, sharedine. inc.</footer>
    </div>
  );
});
