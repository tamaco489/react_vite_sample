const storagePrefix = "react_vite_sample";

/**
 * ストレージを処理するメソッド群
 */
const storage = {
  getToken: () => {
    return JSON.parse(
      window.localStorage.getItem(`${storagePrefix}_token`) as string
    );
  },
  setToken: (token: string) => {
    window.localStorage.setItem(
      `${storagePrefix}_token`,
      JSON.stringify(token)
    );
  },
  clearToken: () => {
    window.localStorage.removeItem(`${storagePrefix}_token`);
  },
};

export default storage;
