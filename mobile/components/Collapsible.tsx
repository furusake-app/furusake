import { type FC, type PropsWithChildren, useState } from "react";
import { TouchableOpacity, View } from "react-native";

import { ThemedText } from "@/components/ThemedText";
import { ThemedView } from "@/components/ThemedView";
import { IconChevronRight } from "@tabler/icons-react-native";
import { Colors } from "@/constants/Colors";
import { useColorScheme } from "@/hooks/useColorScheme";
import { cn } from "@/utils/classnames";

type CollapsibleProps = PropsWithChildren & {
  title: string;
};

export const Collapsible: FC<CollapsibleProps> = ({ children, title }) => {
  const [isOpen, setIsOpen] = useState(false);
  const theme = useColorScheme() ?? "light";

  return (
    <ThemedView>
      <TouchableOpacity
        className="flex-row items-center gap-1.5"
        onPress={() => setIsOpen((value) => !value)}
        activeOpacity={0.8}
      >
        <View className={cn({ "rotate-90": isOpen })}>
          <IconChevronRight
            size={18}
            color={theme === "light" ? Colors.light.icon : Colors.dark.icon}
            strokeWidth={2}
          />
        </View>
        <ThemedText type="defaultSemiBold">{title}</ThemedText>
      </TouchableOpacity>
      {isOpen && <ThemedView className="mt-1.5 ml-6">{children}</ThemedView>}
    </ThemedView>
  );
};
