const getCurrentUrl = () => {
    const { protocol, host } = window.location;
    return `${protocol}//${host}/api`;
};

export const backendBaseUrl = import.meta.env.VITE_BACKEND_BASE_URL ?? getCurrentUrl();
