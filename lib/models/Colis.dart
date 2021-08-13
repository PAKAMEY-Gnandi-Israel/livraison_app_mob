import 'dart:ffi';

class Colis {
  int id;
  String titre;
  String description;
  String adresse_recup;
  String adresse_liv;
  String image_ap;
  String image_av;
  double  largeur;
  double  longueur;
  String statut;
  String engin;
  double  hauteur;
  double  poids;
  double  prix;


  Colis(this.id ,this.titre, this.description, this.adresse_recup, this.adresse_liv,
      this.largeur,this.statut, this.longueur, this.hauteur, this.poids, this.prix , this.image_ap , this.image_av , this.engin);

  Colis.fromJson(Map<String, dynamic> parsedJson) {
    id= parsedJson['id'];
    titre= parsedJson['titre'];
    description = parsedJson['description'];
    adresse_recup = parsedJson['adresse_recup'];
    adresse_liv = parsedJson['adresse_liv'];
    largeur = parsedJson['largeur'];
    longueur = parsedJson['longueur'];
    statut= parsedJson['statut'];
    engin= parsedJson['engin'];
    hauteur = parsedJson['hauteur'];
    poids = parsedJson['poids'];
    prix = parsedJson['prix'];
    image_av = parsedJson['image_av'];
    image_ap = parsedJson['image_ap'];



  }


  Map<String, dynamic> toJson() => {

  };
}
