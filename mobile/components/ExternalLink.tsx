import { type Href, Link } from "expo-router";
import { openBrowserAsync } from "expo-web-browser";
import type { ComponentProps, FC } from "react";
import { Platform } from "react-native";

type ExternalLinkProps = Omit<ComponentProps<typeof Link>, "href"> & {
  href: Href & string;
};

export const ExternalLink: FC<ExternalLinkProps> = ({ href, ...rest }) => (
  <Link
    target="_blank"
    {...rest}
    href={href}
    onPress={async (event) => {
      if (Platform.OS !== "web") {
        event.preventDefault();
        await openBrowserAsync(href);
      }
    }}
  />
);
