import { render, screen } from "@testing-library/react";
import HealthCheck from "../HealthCheck";

describe("HealthCheck Component", () => {
	it("renders health check message", () => {
		render(<HealthCheck />);
		expect(screen.getByText(/system status/i)).toBeInTheDocument();
	});

	it("displays current timestamp", () => {
		render(<HealthCheck />);
		expect(screen.getByText(/timestamp/i)).toBeInTheDocument();
	});
});
