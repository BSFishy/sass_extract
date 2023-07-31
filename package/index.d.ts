export interface ExtractVariableOptions {
    path?: string;
    url?: string;
    syntax?: 'sass' | 'css' | 'scss';
}

export function extractVariablesFromString(contents: string, options?: ExtractVariableOptions): object;

export function extractVariablesFromStringAsync(contents: string, options?: ExtractVariableOptions): Promise<object>;

export interface ExtractVariableFileOptions {
    path?: string;
    syntax?: 'sass' | 'css' | 'scss';
}

export function extractVariablesFromFile(url: string, options?: ExtractVariableFileOptions): object;

export function extractVariablesFromFileAsync(url: string, options?: ExtractVariableFileOptions): Promise<object>;
