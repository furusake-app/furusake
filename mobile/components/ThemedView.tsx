import type { FC } from "react";
import { View, type ViewProps } from "react-native";
import { useThemeColor } from "@/hooks/useThemeColor";
import { cn } from "@/utils/classnames";

type ThemedViewProps = ViewProps & {
  lightColor?: string;
  darkColor?: string;
  className?: string;
};

export const ThemedView: FC<ThemedViewProps> = ({
  style,
  lightColor,
  darkColor,
  className,
  ...otherProps
}) => {
  const backgroundColor = useThemeColor(
    { light: lightColor, dark: darkColor },
    "background",
  );

  return (
    <View
      style={[{ backgroundColor }, style]}
      className={cn(className)}
      {...otherProps}
    />
  );
};
