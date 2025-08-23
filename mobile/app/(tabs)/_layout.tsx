import { IconHome, IconSearch } from "@tabler/icons-react-native";
import { Tabs } from "expo-router";

const TabLayout = () => (
  <Tabs
    screenOptions={{
      headerShown: false,
    }}
  >
    <Tabs.Screen
      name="index"
      options={{
        title: "Home",
        tabBarIcon: ({ color }) => (
          <IconHome size={24} color={color} strokeWidth={2} />
        ),
      }}
    />
    <Tabs.Screen
      name="explore"
      options={{
        title: "Explore",
        tabBarIcon: ({ color }) => (
          <IconSearch size={24} color={color} strokeWidth={2} />
        ),
      }}
    />
  </Tabs>
);

export default TabLayout;
