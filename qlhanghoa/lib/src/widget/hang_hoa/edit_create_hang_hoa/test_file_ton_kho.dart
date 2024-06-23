 /* Widget _buildFieldTonKho() {
    return TextFormField(
      onSaved: (newValue) {
        var va = newValue.toString().replaceAll(',', '');
        controller.hangHoaModel =
            controller.hangHoaModel.copyWith(tonKho: double.parse(va));
      },
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      validator: (value) {
        if (controller.quanLyTheoLo.value != true) {
          // loại bỏ các dấu "," khỏi chuỗi
          var va = value.toString().replaceAll(',', '');
          // sao đó kiểm tra
          if ((va.isEmpty)) {
            return 'Vui lòng nhập tồn kho';
          }
          if (double.tryParse(va) == null) {
            return 'Vui lòng nhập vào giá trị số';
          }
          if (double.parse(va) < 0) {
            return 'Giá trị phải lớn hơn hoặc bằng 0';
          }
          return null;
        }
        return null;
      },
      controller: controller.tonKhoController,
      style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        errorStyle: TextStyle(fontSize: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorClass.color_button, width: 1.2),
        ),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        hintText: '0',
        hintStyle:
            TextStyle(color: Color.fromARGB(43, 10, 4, 126), fontSize: 14),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          controller.tonKhoController.text = '0';
        }
        int count = value.split('.').length - 1;
        print('đếm');
        print(count);
        if (count > 1) {
          value = value.substring(0, value.length - 1).toString();
        }

        if (double.tryParse(value) != null && !value.endsWith('.')) {
          print('gọi');
          //  print(FunctionHelper.formNum(value));
          controller.tonKhoController.text = FunctionHelper.formNum(value);
        }
        //controller.text = FunctionHelper.formNum(value);
      },
      onEditingComplete: () {
        //  print('gọi complete');
        controller.tonKhoController.text =
            controller.tonKhoController.text.toString().replaceAll(',', '');
        if (double.tryParse(controller.tonKhoController.text) == null) {
          controller.tonKhoController.text = '0';
        } else {
          controller.tonKhoController.text =
              FunctionHelper.formNum(controller.tonKhoController.text);
        }
      },
    );
  } */