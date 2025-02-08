import { useQueryErrorResetBoundary } from "@tanstack/react-query";
import { useRouteError } from "react-router";

import { Button } from "@/components/ui/button";

type Props = {
  status?: string;
  message?: string;
};

/**
 * エラー画面
 * @param param0
 * @returns
 */
export const Error = ({ status, message }: Props) => {
  const error = useRouteError();
  const { reset } = useQueryErrorResetBoundary();

  return (
    <div
      role="alert"
      className="flex h-screen flex-col items-center justify-center"
    >
      <h1>
        {status || (error as Response).status || (error as Error).message}
      </h1>
      <p>
        {message ||
          (error as Response).statusText ||
          ((error as Error).cause as string)}
      </p>
      <Button
        onClick={() => {
          reset();
          window.location.assign(window.location.origin);
        }}
      >
        ホームへ
      </Button>
    </div>
  );
};
