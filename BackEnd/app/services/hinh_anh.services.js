

const { getStorage, ref ,uploadBytesResumable, getDownloadURL } = require('firebase/storage')
const { signInWithEmailAndPassword, createUserWithEmailAndPassword } = require("firebase/auth");
const { auth } = require('../firebase/firebase');
require('dotenv').config();


async function uploadImage(file, quantity) {
    const storageFB = getStorage();

    await signInWithEmailAndPassword(auth, process.env.FIREBASE_USER, process.env.FIREBASE_AUTH)
    let data = {
      ten_anh: null,
      link_anh: null
    }
    if (quantity === 'single') {
    
        const fileName = `images/${file.originalname}`
        const storageRef = ref(storageFB, fileName)
        const metadata = {
            contentType: file.mimetype,
        }
        await uploadBytesResumable(storageRef, file.buffer, metadata);
        const url = await getDownloadURL(storageRef);
        // đưa url vào danh sách ảnh
        data.link_anh = url;
        data.ten_anh = fileName;
        return data;
    }

    if (quantity === 'multiple') {
      let listURL = [];
      
        for(let i=0; i < file.length; i++) {
           // const dateTime = Date.now();
            const fileName = `images/${file[i].originalname}`
            const storageRef = ref(storageFB, fileName)
            const metadata = {
                contentType: file[i].mimetype,
            }


            await uploadBytesResumable(storageRef, file[i].buffer, metadata);
            let url = await getDownloadURL(storageRef);
            data.link_anh = url;
           data.ten_anh = fileName;
          listURL.push(data);

        }
        return listURL;
    }

}

module.exports= {
    uploadImage
}