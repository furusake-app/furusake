import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import "../styles/global.css";
import "react-native-reanimated";

const RootLayout = () => (
  <Stack>
    <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
    <Stack.Screen name="+not-found" />
    <StatusBar style="auto" />
  </Stack>
);

export default RootLayout;
