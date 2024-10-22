{ pkgs, ... }:

{
    fonts.packages = with pkgs; [
        # Fonts
        nerdfonts
        powerline

        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji

        fira-code
        fira-code-symbols
    ];
}