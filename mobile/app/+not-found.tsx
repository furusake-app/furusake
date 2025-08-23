import { Link, Stack } from "expo-router";
import { View, Text } from "react-native";

const NotFoundScreen = () => (
  <>
    <Stack.Screen options={{ title: "Oops!" }} />
    <View className="flex-1 items-center justify-center p-5">
      <Text className="text-3xl font-bold">This screen does not exist.</Text>
      <Link href="/" className="mt-4 py-4">
        <Text className="text-blue-600">Go to home screen!</Text>
      </Link>
    </View>
  </>
);

export default NotFoundScreen;
