import * as React from "react";
import { Link } from "react-router";

import { Button } from "@/components/ui/button";
import { useAuth } from "@/lib/auth0";

export const Header = React.memo(() => {
  const { logout, isAuthenticated } = useAuth();
  return (
    <header className="fixed z-10 w-full">
      <div className="relative flex h-[55px] w-full items-center">
        <div className="w-auto grow items-center truncate text-center ">
          <Link to={{ pathname: "/" }}>react_vite_sample画面</Link>
        </div>
        {isAuthenticated && (
          <>
            <Button
              onClick={async () => {
                await logout();
              }}
            >
              ログアウト
            </Button>
          </>
        )}
      </div>
    </header>
  );
});
