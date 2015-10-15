#include <stdint.h>

/*
入力の非正規化数は0として扱う。
演算の結果、非正規化数となった場合+0を返す。
1つ以上のNaNが入力としてきた場合、NaNを返す。
丸め処理はnearest even。
*/

uint32_t fadd(uint32_t a, uint32_t b)
{
	uint32_t w;
	uint32_t l;
	uint32_t w_sign;
	uint32_t l_sign;
	uint32_t w_expo;
	uint32_t l_expo;
	uint32_t w_frac;
	uint32_t l_frac;
	uint32_t shift;
	uint32_t tmp_frac1;
	uint32_t tmp_frac2;
	uint32_t expo;
	uint32_t frac;
	uint32_t pluszero = 0;
	uint32_t minuszero = 0x80000000;
	uint32_t plusinf = 0x7F800000;
	uint32_t minusinf = 0xFF800000;
	uint32_t nan = 0x7FC00000;
	uint32_t count = 0;
	int flag = 0;

	if((a<<1) >= (b<<1)){
		w = a;
		l = b;
	}
	else{
		w = b;
		l = a;
	}
	//指数が大きいほうがwで小さい方がl(指数が同じ場合仮数で比較するが、それも同じならaがw)

    w_sign = w>>31;
    l_sign = l>>31;
	w_expo = (w & 0x7F800000)>>23;
	l_expo = (l & 0x7F800000)>>23;
	w_frac = w & 0x7FFFFF;
	l_frac = l & 0x7FFFFF;

	if(w_expo==255){
		if(l_expo==255 && w_sign!=l_sign) return nan;
		else return w;
	}

	if(l_expo==0){
		if(w_expo==0){
			if(w_sign==1 && l_sign==1) return minuszero;
			//プラスゼロとマイナスゼロの入力に対してはプラスゼロを返す
			else return pluszero;
		}
		else return w;
	}

	shift = w_expo - l_expo;

	if(shift>25) return w;

	if(w_sign==l_sign){
		tmp_frac1 = (l_frac + 0x800000) << 1;
		while(shift>0){
			if((tmp_frac1 & 1) == 1) flag = 1;
			tmp_frac1 = tmp_frac1 >>1;
			shift = shift - 1;
		}
		tmp_frac2 = ((w_frac + 0x800000) << 1) + tmp_frac1;
		if((tmp_frac2 & 0x2000000) == 0x2000000){
			if(w_expo==254){
	  			if(w_sign==0) return plusinf;
	  			else return minusinf;
			}
			else{
				frac = (tmp_frac2 >> 2) - 0x800000; 
				if(((tmp_frac2 & 2) == 2) && (((tmp_frac2 & 1) == 1) || ((tmp_frac2 & 4) == 4) || (flag == 1))) frac = frac + 1; 
				expo = w_expo + 1;
			}
		}
		else{
			if(((tmp_frac2 & 1) == 1) && (((tmp_frac2 & 2) == 2) || (flag == 1))) tmp_frac2 = tmp_frac2 + 1;
			if((tmp_frac2 & 0x2000000) == 0x2000000){
				frac = (tmp_frac2 >> 2) - 0x800000; 
				expo = w_expo + 1;
			}
			else{
				frac = (tmp_frac2 >> 1) - 0x800000;
				expo = w_expo;
			}
		}
	}

	else{
		if(shift>1){
			tmp_frac1 = (l_frac + 0x800000) << 2; 
			while(shift>0){
				if((tmp_frac1 & 1) == 1) flag = 1;
				tmp_frac1 = tmp_frac1 >>1;
				shift = shift - 1;
			}
			tmp_frac2 = ((w_frac + 0x800000) << 2) - tmp_frac1;
			if((tmp_frac2 & 0x2000000) == 0x2000000){
				expo = w_expo;
				frac = (tmp_frac2>>2) - 0x800000;
				if(((tmp_frac2 & 3) == 3) || (((tmp_frac2 & 7) == 6) && (flag == 0))) frac = frac + 1;				
			}
			else{
				frac = tmp_frac2>>1;
				if(((tmp_frac2 & 3) == 3) && (flag == 0)) frac = frac + 1;
				if((frac & 0x1000000) == 0x1000000){
					frac = (frac>>1) - 0x800000;
					expo = w_expo;
				}
				else{
					frac = frac - 0x800000;
					expo = w_expo - 1;
				}
			}
		}
		else{
			tmp_frac1 = ((w_frac + 0x800000)<<shift) - (l_frac + 0x800000);
			if(tmp_frac1==0) return 0;
			while((tmp_frac1 & (0x800000<<shift)) != (0x800000<<shift)){
				count++;
				tmp_frac1 = tmp_frac1 << 1;
			}
			if(w_expo < (count + 1)) return 0;
			expo = w_expo - count;
			if(count == 0 && ((tmp_frac1 & 3) == 3)) frac = (tmp_frac1 >> 1) + 1 -0x800000;
			else frac = (tmp_frac1>>shift) - 0x800000;
		}
	}

	return ((w_sign<<31) | (expo<<23) | frac);

}

