import type { FC } from "react";
import { Text, type TextProps } from "react-native";
import { useThemeColor } from "@/hooks/useThemeColor";
import { cn } from "@/utils/classnames";

type ThemedTextProps = TextProps & {
  lightColor?: string;
  darkColor?: string;
  type?: "default" | "title" | "defaultSemiBold" | "subtitle" | "link";
  className?: string;
};

export const ThemedText: FC<ThemedTextProps> = ({
  style,
  lightColor,
  darkColor,
  type = "default",
  className,
  ...rest
}) => {
  const color = useThemeColor({ light: lightColor, dark: darkColor }, "text");

  return (
    <Text
      style={[{ color: type === "link" ? "#0a7ea4" : color }, style]}
      className={cn(
        type === "default" && "text-base leading-6",
        type === "title" && "text-3xl font-bold leading-8",
        type === "defaultSemiBold" && "text-base font-semibold leading-6",
        type === "subtitle" && "text-xl font-bold",
        type === "link" && "text-base leading-7.5 text-blue-600",
        className,
      )}
      {...rest}
    />
  );
};
