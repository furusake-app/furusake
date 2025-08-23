import type { BottomTabBarButtonProps } from "@react-navigation/bottom-tabs";
import { PlatformPressable } from "@react-navigation/elements";
import * as Haptics from "expo-haptics";

export const HapticTab = (props: BottomTabBarButtonProps) => (
  <PlatformPressable
    {...props}
    onPressIn={(e) => {
      if (process.env.EXPO_OS === "ios") {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
      }
      props.onPressIn?.(e);
    }}
  />
);
