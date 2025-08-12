const HealthCheck = () => {
	return (
		<div>
			<h2>System Status: OK</h2>
			<p>Timestamp: {new Date().toISOString()}</p>
			<p>Space Booking System - Clean Architecture Demo</p>
		</div>
	);
};

export default HealthCheck;
