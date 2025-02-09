import { useAuth0 } from "@auth0/auth0-react";

/**
 * 認証したユーザー情報を取得する
 *
 * @returns 認証情報
 * @returns login ログイン処理
 * @returns logout ログアウト処理
 * @returns user ユーザー情報
 * @returns isAuthenticated 認証状態
 * @returns isLoading ローディング状態
 * @returns getAccessTokenSilently アクセストークン取得
 */
export const useAuth = () => {
  const {
    loginWithRedirect,
    logout,
    user,
    isAuthenticated,
    isLoading,
    getAccessTokenSilently,
    error,
  } = useAuth0();

  return {
    login: () =>
      loginWithRedirect({ appState: { returnTo: window.location.pathname } }),
    isLoading,
    logout: () =>
      logout({ logoutParams: { returnTo: window.location.origin } }),
    user,
    isAuthenticated,
    getAccessTokenSilently,
    error,
  };
};
