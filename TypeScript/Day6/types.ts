declare global {
    interface Document {
        querySelector<K extends keyof HTMLElementTagNameMap>(
            selectors: K
        ): HTMLElementTagNameMap[K];
    }
}
export {};
