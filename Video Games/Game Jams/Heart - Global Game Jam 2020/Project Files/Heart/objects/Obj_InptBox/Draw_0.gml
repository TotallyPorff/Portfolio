//draw textbox
draw_sprite(Spr_PlayerBox, -1, x, y);

//draw text
draw_set_font(Fnt_Text);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

if (charCount < string_length(text)) {
	charCount += 0.5;
}
textPart = string_copy(text, 1, charCount);
draw_text_ext(x, y, textPart, strHeight, txtBoxWidth - 12);