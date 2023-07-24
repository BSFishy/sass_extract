export interface ExtractVariableOptions {
    path?: string;
}

export function extractVariablesFromString(contents: string, options?: ExtractVariableOptions): object;
