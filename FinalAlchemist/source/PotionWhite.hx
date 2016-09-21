package;

class PotionWhite extends Potion
{
    public function new(){super(); color = Potion.WHITE; colorString = "white"; }

	override function drink(player:Player){
		//White is an empty bottle, it still needs a tootip but it doesnt need any other potion logic
		if (Level.firsts.exists(colorString) && Level.firsts.get(colorString) != null){
			HUD.instance.updateHUD(Level.firsts.get(colorString));
			Level.firsts.set(colorString,null);
		}
	}
}