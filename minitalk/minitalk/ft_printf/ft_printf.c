/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rhanitra <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/28 08:41:25 by rhanitra          #+#    #+#             */
/*   Updated: 2024/04/06 17:12:20 by rhanitra         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdarg.h>
#include <unistd.h>
#include "ft_printf.h"

int	ft_find_item(char type, va_list args)
{
	int		i;

	i = 0;
	if (type == '%')
		i += write(1, "%", 1);
	else if (type == 'c')
		i += ft_print_char(va_arg(args, int));
	else if (type == 's')
		i += ft_print_str(va_arg(args, char *));
	else if (type == 'd' || type == 'i')
		i += ft_print_int(va_arg(args, int));
	else if (type == 'u')
		i += ft_print_uint(va_arg(args, unsigned int), "0123456789", 10);
	else if (type == 'x')
		i += ft_print_hexa(va_arg(args, unsigned int),
				"0123456789abcdef", 16);
	else if (type == 'X')
		i += ft_print_hexa(va_arg(args, unsigned int),
				"0123456789ABCDEF", 16);
	else if (type == 'p')
		i += ft_print_pointer((unsigned long)va_arg(args, void *),
				"0123456789abcdef", 16);
	return (i);
}

int	ft_printf(const char *format, ...)
{
	int		i;
	int		j;
	va_list	args;

	i = 0;
	j = 0;
	va_start(args, format);
	while (format[i] != '\0')
	{
		if (format[i] == '%')
		{
			i++;
			j += ft_find_item(format[i], args);
		}
		else
			j += write(1, &format[i], 1);
		i++;
	}
	va_end(args);
	return (j);
}
