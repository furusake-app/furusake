import * as api from "furusake-api";

const Home = async () => {
  const res = await api.healthCheck();

  if (res.status !== 200) {
    return <div>Failed to fetch health check data</div>;
  }

  return (
    <div>
      <div>API Health Check: {res.data.status}</div>
      <div>Database Health Check: {res.data.database}</div>
    </div>
  );
};

export default Home;
