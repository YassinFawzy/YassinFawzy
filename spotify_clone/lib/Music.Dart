class Music {
  String title;
  String subtitle;
  String imagePath;

  Music(
      this.title,
      this.subtitle,
      this.imagePath);
}

List<Music> getMusicList() {
  return <Music>[
    Music(
      "SALE",
      "Abdullah's Villa",
      "3,500,.00",

    ),
  ];
}
