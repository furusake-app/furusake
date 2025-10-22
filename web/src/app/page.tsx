import { parseResponse } from "hono/client";
import { apiClient } from "@/lib/api-client";

const Home = async () => {
  const res = await parseResponse(apiClient.$get());

  return (
    <div>
      <div>{JSON.stringify(res)}</div>
    </div>
  );
};

export default Home;
