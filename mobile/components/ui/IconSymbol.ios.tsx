import {
  SymbolView,
  type SymbolViewProps,
  type SymbolWeight,
} from "expo-symbols";
import type { FC } from "react";
import type { StyleProp, ViewStyle } from "react-native";
import { View } from "react-native";
import { cn } from "@/utils/classnames";

type IconSymbolProps = {
  name: SymbolViewProps["name"];
  size?: number;
  color: string;
  style?: StyleProp<ViewStyle>;
  className?: string;
  weight?: SymbolWeight;
};

export const IconSymbol: FC<IconSymbolProps> = ({
  name,
  size = 24,
  color,
  className,
  weight = "regular",
}) => (
  <View className={cn(className)}>
    <SymbolView
      weight={weight}
      tintColor={color}
      resizeMode="scaleAspectFit"
      name={name}
      style={[
        {
          width: size,
          height: size,
        },
      ]}
    />
  </View>
);
