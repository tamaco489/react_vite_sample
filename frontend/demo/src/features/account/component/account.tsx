import { useSuspenseQuery } from "@tanstack/react-query";
import React from "react";

import { fetchAccount, queryKey } from "@/features/account/api/fetch-account";

/**
 * アカウント画面
 */
export const Account: React.FC = React.memo(() => {
  const { data } = useSuspenseQuery({
    queryKey,
    queryFn: fetchAccount,
  });
  return (
    <div className=" mx-auto mt-[100px] max-w-[400px]">
      <h2 className="mb-[60px] text-center">ログイン成功</h2>
      <div>{data.status === 404 && <>ユーザーが存在しません</>}</div>
    </div>
  );
});
