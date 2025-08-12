// Global type definitions
export interface User {
	id: number;
	email: string;
	name: string;
	companyId: number;
	roles: string[];
}

export interface Company {
	id: number;
	name: string;
	subdomain: string;
	settings: CompanySettings;
}

export interface CompanySettings {
	workingHours: {
		start: string;
		end: string;
	};
	timeZone: string;
	features: string[];
}

export interface ApiResponse<T> {
	data: T;
	message?: string;
	errors?: string[];
}

export interface ApiError {
	message: string;
	status: number;
	errors?: Record<string, string[]>;
}
