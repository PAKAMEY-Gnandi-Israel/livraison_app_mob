import 'dart:ffi';

class Colis {
int id;
  String titre;
  String description;
   String adresse_recup;
   String adresse_liv;
  String image_ap;
  String image_av;
  Double  largeur;
  Double  longueur;

  Double  hauteur;
  Double  poids;
  Double  prix;


  Colis(this.id ,this.titre, this.description, this.adresse_recup, this.adresse_liv,
      this.largeur, this.longueur, this.hauteur, this.poids, this.prix , this.image_ap , this.image_av);

  Colis.fromJson(Map<String, dynamic> parsedJson) {
    id= parsedJson['id'];
    titre= parsedJson['titre'];
    description = parsedJson['description'];
    adresse_recup = parsedJson['adresse_recup'];
    adresse_liv = parsedJson['adresse_liv'];
    largeur = parsedJson['longueur'];
    hauteur = parsedJson['hauteur'];
    poids = parsedJson['poids'];
    prix = parsedJson['prix'];
    image_av = parsedJson['image_av_emball'];
    image_ap = parsedJson['image_ap_emball'];



  }


  Map<String, dynamic> toJson() => {

  };
}
