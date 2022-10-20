package status.config;

class Config{
	public var GitlabToken:String;
	public var GithubToken:String;
	public var RefreshTime:Int;
	public var ClearStatus:Int;
	public var Message:Array<String>;
	public var Agenda:Array<Array<String>>;

	public function new(){}
}