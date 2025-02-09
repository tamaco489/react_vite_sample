/* 環境変数 (dev, stg, prd) */
export const APP_ENV = import.meta.env.VITE_APP_ENV as string;

/* apiサーバのURL */
export const API_URL = import.meta.env.VITE_APP_API_URL as string;

/* Auth0の環境変数 */
export const AUTH0_CONFIG = {
  DOMAIN: import.meta.env.VITE_AUTH0_DOMAIN as string,
  CLIENT_ID: import.meta.env.VITE_AUTH0_CLIENT_ID as string,
  AUDIENCE: import.meta.env.VITE_AUTH0_AUDIENCE as string,
};
