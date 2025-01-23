import 'package:news_application/model/catagoryModel.dart';


List<Catagorymodel> getCatagories(){
  List<Catagorymodel> catagory=[];
  Catagorymodel catagorymodel=new Catagorymodel();

  catagorymodel.catagoryName="Business";
  catagorymodel.image="images/business.jpg";
  catagory.add(catagorymodel);
  catagorymodel=new Catagorymodel();
  

  catagorymodel.catagoryName="Entertainment";
  catagorymodel.image="images/entertainment.jpg";
  catagory.add(catagorymodel);
  catagorymodel=new Catagorymodel();
   
  catagorymodel.catagoryName="General";
  catagorymodel.image="images/general.jpg";
  catagory.add(catagorymodel);
  catagorymodel=new Catagorymodel(); 

  catagorymodel.catagoryName="Health";
  catagorymodel.image="images/health.png";
  catagory.add(catagorymodel);
  catagorymodel=new Catagorymodel();
  
  catagorymodel.catagoryName="Sports";
  catagorymodel.image="images/sports.jpg";
  catagory.add(catagorymodel);
  catagorymodel=new Catagorymodel();

  return catagory;
}