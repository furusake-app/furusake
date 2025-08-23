import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import type { SymbolViewProps } from "expo-symbols";
import type { ComponentProps, FC } from "react";
import type { OpaqueColorValue, StyleProp, TextStyle } from "react-native";
import { cn } from "@/utils/classnames";

type IconMapping = Record<
  SymbolViewProps["name"],
  ComponentProps<typeof MaterialIcons>["name"]
>;
type IconSymbolName = keyof typeof MAPPING;

type IconSymbolProps = {
  name: IconSymbolName;
  size?: number;
  color: string | OpaqueColorValue;
  style?: StyleProp<TextStyle>;
  className?: string;
};

const MAPPING = {
  "house.fill": "home",
  "paperplane.fill": "send",
  "chevron.left.forwardslash.chevron.right": "code",
  "chevron.right": "chevron-right",
} as IconMapping;

export const IconSymbol: FC<IconSymbolProps> = ({
  name,
  size = 24,
  color,
  style,
  className,
}) => (
  <MaterialIcons
    color={color}
    size={size}
    name={MAPPING[name]}
    style={style}
    className={cn(className)}
  />
);
