import * as api from "furusake-api";

const Home = async () => {
  const { data } = await api.healthCheck();

  return <div>API Health Check: {data?.status ?? "No status available"}</div>;
};

export default Home;
