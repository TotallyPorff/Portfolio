//draw textbox
draw_sprite(Spr_HeartBox, -1, boxPosX, boxPosY);

//draw text
draw_set_font(Fnt_Text);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

if (charCount < string_length(text)) {
	charCount += 0.5;
}
textPart = string_copy(text, 1, charCount);
draw_text_ext(txtPosX, txtPosY, textPart, strHeight, txtBoxWidth - 12);
