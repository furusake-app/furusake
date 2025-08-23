import { IconHome, IconSearch } from "@tabler/icons-react-native";
import { Link, Slot, usePathname } from "expo-router";
import { Text, TouchableOpacity, View } from "react-native";

const TabLayout = () => {
  const pathname = usePathname();

  return (
    <View className="flex-1 bg-background">
      <View className="flex-1">
        <Slot />
      </View>
      <View className="flex-row border-t border-border bg-background">
        <Link href="/" asChild>
          <TouchableOpacity className="flex-1 items-center py-3">
            <IconHome
              size={24}
              className={pathname === "/" ? "text-primary" : "text-icon"}
              strokeWidth={2}
            />
            <Text
              className={`text-xs mt-1 ${pathname === "/" ? "text-primary" : "text-icon"}`}
            >
              Home
            </Text>
          </TouchableOpacity>
        </Link>
        <Link href="/explore" asChild>
          <TouchableOpacity className="flex-1 items-center py-3">
            <IconSearch
              size={24}
              className={pathname === "/explore" ? "text-primary" : "text-icon"}
              strokeWidth={2}
            />
            <Text
              className={`text-xs mt-1 ${pathname === "/explore" ? "text-primary" : "text-icon"}`}
            >
              Explore
            </Text>
          </TouchableOpacity>
        </Link>
      </View>
    </View>
  );
};

export default TabLayout;
